{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01024') }},
        {{ ref('model_01257') }},
        {{ ref('model_00960') }}
)
select id, 'model_02025' as name from sources
