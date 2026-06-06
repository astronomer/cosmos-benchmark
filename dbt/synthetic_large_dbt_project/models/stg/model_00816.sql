{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00069') }},
        {{ ref('model_00358') }},
        {{ ref('model_00262') }}
)
select id, 'model_00816' as name from sources
