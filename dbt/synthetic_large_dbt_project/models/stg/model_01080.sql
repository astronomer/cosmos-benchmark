{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00492') }},
        {{ ref('model_00653') }}
)
select id, 'model_01080' as name from sources
