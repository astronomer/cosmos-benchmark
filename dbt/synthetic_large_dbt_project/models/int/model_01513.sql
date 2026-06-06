{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00815') }},
        {{ ref('model_01024') }},
        {{ ref('model_01413') }}
)
select id, 'model_01513' as name from sources
