{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01670') }},
        {{ ref('model_01883') }},
        {{ ref('model_01662') }}
)
select id, 'model_02439' as name from sources
