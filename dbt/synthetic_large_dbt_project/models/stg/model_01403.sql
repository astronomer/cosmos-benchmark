{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00351') }},
        {{ ref('model_00553') }},
        {{ ref('model_00559') }}
)
select id, 'model_01403' as name from sources
