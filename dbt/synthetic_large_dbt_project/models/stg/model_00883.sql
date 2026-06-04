{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00666') }},
        {{ ref('model_00038') }},
        {{ ref('model_00384') }}
)
select id, 'model_00883' as name from sources
