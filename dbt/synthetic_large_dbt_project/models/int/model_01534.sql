{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00821') }},
        {{ ref('model_00836') }},
        {{ ref('model_01096') }}
)
select id, 'model_01534' as name from sources
