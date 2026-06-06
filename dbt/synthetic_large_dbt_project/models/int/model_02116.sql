{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00866') }},
        {{ ref('model_00771') }}
)
select id, 'model_02116' as name from sources
