{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00372') }},
        {{ ref('model_00687') }}
)
select id, 'model_01434' as name from sources
