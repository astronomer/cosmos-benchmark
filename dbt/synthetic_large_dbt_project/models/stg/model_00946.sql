{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00262') }},
        {{ ref('model_00553') }}
)
select id, 'model_00946' as name from sources
