{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01558') }},
        {{ ref('model_01614') }}
)
select id, 'model_02541' as name from sources
