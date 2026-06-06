{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00548') }},
        {{ ref('model_00433') }}
)
select id, 'model_01005' as name from sources
