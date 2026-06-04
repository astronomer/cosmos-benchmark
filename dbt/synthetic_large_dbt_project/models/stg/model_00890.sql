{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00508') }},
        {{ ref('model_00212') }},
        {{ ref('model_00704') }}
)
select id, 'model_00890' as name from sources
