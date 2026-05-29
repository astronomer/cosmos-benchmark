{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00372') }},
        {{ ref('model_00055') }}
)
select id, 'model_00912' as name from sources
