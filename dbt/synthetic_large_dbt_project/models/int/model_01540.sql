{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00836') }},
        {{ ref('model_00787') }}
)
select id, 'model_01540' as name from sources
